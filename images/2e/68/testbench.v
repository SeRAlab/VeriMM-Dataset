`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [31:0] x0;
    reg [31:0] x1;
    reg [31:0] x2;
    reg [31:0] x3;
    wire [31:0] y0;
    wire [31:0] y1;
    wire [31:0] y2;
    wire [31:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .clk(clk),
        .rst(rst),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x0 = 0; x1 = 0; x2 = 0; x3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            x0 = 32'h00000000;
            x1 = 32'h00000000;
            x2 = 32'h00000000;
            x3 = 32'h00000000;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: RFC 7539 Test Vector", test_num);
            reset_dut();
            x0 = 32'h11111111;
            x1 = 32'h01020304;
            x2 = 32'h9b8d6f43;
            x3 = 32'h01234567;

            repeat(5) @(posedge clk);



            #1;




            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: All Fs Overflow Test", test_num);
            reset_dut();
            x0 = 32'hffffffff;
            x1 = 32'hffffffff;
            x2 = 32'hffffffff;
            x3 = 32'hffffffff;

            repeat(5) @(posedge clk);






            #1;







            check_outputs(32'h0000fffd, 32'h00018001, 32'h0200fcff, 32'h01fffd00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bits", test_num);
            reset_dut();
            x0 = 32'haaaaaaaa;
            x1 = 32'h55555555;
            x2 = 32'haaaaaaaa;
            x3 = 32'h55555555;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(32'h751e7195, 32'h95c61304, 32'h35552a8a, 32'h8bb6750e);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_y0;
        input [31:0] expected_y1;
        input [31:0] expected_y2;
        input [31:0] expected_y3;
        begin
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%h, y1=%h, y2=%h, y3=%h",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%h, y1=%h, y2=%h, y3=%h",
                         y0, y1, y2, y3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, rst, x0, x1, x2, x3, y0, y1, y2, y3);
    end

endmodule
