// traffic_light_controller.v
// 4-way traffic light controller using Moore FSM

module traffic_light_controller #(
    parameter GREEN_TIME  = 10, // no. of clk cycles for GREEN
    parameter YELLOW_TIME = 3   // no. of clk cycles for YELLOW
)(
    input  wire       clk,
    input  wire       rst,       // active-high synchronous reset
    output reg  [2:0] NS_light,  // North-South lights: [2]=R, [1]=Y, [0]=G
    output reg  [2:0] EW_light   // East-West   lights: [2]=R, [1]=Y, [0]=G
);

    // State encoding
    localparam S_NS_GREEN_EW_RED   = 2'd0,
               S_NS_YELLOW_EW_RED  = 2'd1,
               S_NS_RED_EW_GREEN   = 2'd2,
               S_NS_RED_EW_YELLOW  = 2'd3;

    // Light encodings
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    reg [1:0]  state;   // current state
    reg [31:0] timer;   // simple counter for timing

    // Sequential logic: state + timer update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_NS_GREEN_EW_RED; // start with NS green, EW red
            timer <= 0;
        end else begin
            case (state)
                S_NS_GREEN_EW_RED: begin
                    if (timer == GREEN_TIME - 1) begin
                        state <= S_NS_YELLOW_EW_RED;
                        timer <= 0;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                S_NS_YELLOW_EW_RED: begin
                    if (timer == YELLOW_TIME - 1) begin
                        state <= S_NS_RED_EW_GREEN;
                        timer <= 0;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                S_NS_RED_EW_GREEN: begin
                    if (timer == GREEN_TIME - 1) begin
                        state <= S_NS_RED_EW_YELLOW;
                        timer <= 0;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                S_NS_RED_EW_YELLOW: begin
                    if (timer == YELLOW_TIME - 1) begin
                        state <= S_NS_GREEN_EW_RED;
                        timer <= 0;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                default: begin
                    state <= S_NS_GREEN_EW_RED;
                    timer <= 0;
                end
            endcase
        end
    end

    // Combinational logic: outputs based on current state (Moore FSM)
    always @(*) begin
        case (state)
            S_NS_GREEN_EW_RED:  begin
                NS_light = GREEN;
                EW_light = RED;
            end

            S_NS_YELLOW_EW_RED: begin
                NS_light = YELLOW;
                EW_light = RED;
            end

            S_NS_RED_EW_GREEN:  begin
                NS_light = RED;
                EW_light = GREEN;
            end

            S_NS_RED_EW_YELLOW: begin
                NS_light = RED;
                EW_light = YELLOW;
            end

            default: begin
                NS_light = RED;
                EW_light = RED;
            end
        endcase
    end

endmodule