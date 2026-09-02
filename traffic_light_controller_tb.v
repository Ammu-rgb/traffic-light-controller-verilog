// traffic_light_controller_tb.v
`timescale 1ns / 1ps

module traffic_light_controller_tb;

    reg clk = 0;
    reg rst = 1;
    wire [2:0] NS_light;
    wire [2:0] EW_light;

    // Design Under Test (DUT)
    traffic_light_controller #(
        .GREEN_TIME(10),   // simulation ke liye chhote values
        .YELLOW_TIME(3)
    ) dut (
        .clk(clk),
        .rst(rst),
        .NS_light(NS_light),
        .EW_light(EW_light)
    );

    // 100 MHz clock (period = 10 ns)
    always #5 clk = ~clk;

    initial begin
        // waveform dump for GTKWave / EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, traffic_light_controller_tb);

        $display("time\tNS\tEW");
        $monitor("%0t\t%b\t%b", $time, NS_light, EW_light);

        // reset phase
        #20  rst = 0;      // reset release
        #300 $finish;      // simulation stop time
    end

endmodule