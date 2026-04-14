`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] mu;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .mu(mu),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            d = 0;
            mu = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Response", test_num);
            reset_dut();

            mu = 16'h0100;
            x = 16'h0000;
            d = 16'h4000;

            for (i = 0; i < 50; i = i + 1) begin
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: DC Convergence (Unity Tracking)", test_num);
            reset_dut();

            mu = 16'h0800;
            x = 16'h2000;
            d = 16'h2000;


            for (i = 0; i < 200; i = i + 1) begin
                @(posedge clk);
            end



            #1;




            check_outputs(16'h2000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Scaling Convergence", test_num);
            reset_dut();

            mu = 16'h0400;
            x = 16'h4000;
            d = 16'h2000;

            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
            end


            #1;



            check_outputs(16'h2000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Signal Tracking", test_num);
            reset_dut();

            mu = 16'h1000;

            for (i = 0; i < 400; i = i + 1) begin
                x = (i % 2 == 0) ? 16'h2000 : 16'hE000;
                d = x;
                @(posedge clk);
            end



            #1;




            check_outputs(16'hE000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, mu, rst, x, y);
    end

endmodule
