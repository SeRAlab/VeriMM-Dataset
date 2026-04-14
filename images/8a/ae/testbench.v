`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [47:0] X;
    reg [59:0] Y;
    wire [47:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .X(X),
        .Y(Y),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            X = 48'h0;
            Y = 60'h0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: All Zeros...", test_num);
            reset_dut();
            X = 48'h0;
            Y = 60'h0;
            @(posedge CLK); #2;
            #1;

            check_outputs(reference_model(48'h0, 60'h0));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: All Ones...", test_num);
            reset_dut();
            X = {48{1'b1}};
            Y = {60{1'b1}};
            @(posedge CLK); #2;
            #1;

            check_outputs(reference_model({48{1'b1}}, {60{1'b1}}));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Alternating Patterns...", test_num);
            reset_dut();
            X = 48'hAAAAAAAAAAAAAAAA;
            Y = 60'h555555555555555;
            @(posedge CLK); #2;
            #1;

            check_outputs(reference_model(48'hAAAAAAAAAAAAAAAA, 60'h555555555555555));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Walking One in X...", test_num);
            reset_dut();
            X = 48'h000000000001;
            Y = 60'hF0F0F0F0F0F0F0F;
            repeat(5) begin
                @(posedge CLK); #2;
                #1;

                check_outputs(reference_model(X, Y));
                X = X << 8;
            end
        end
        endtask

    task testcase005;

        reg [47:0] rand_x;
        reg [59:0] rand_y;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Random Data Stress...", test_num);
            reset_dut();
            repeat(10) begin
                rand_x = {$random, $random};
                rand_y = {$random, $random, $random};
                X = rand_x;
                Y = rand_y;
                @(posedge CLK); #2;
                #1;

                check_outputs(reference_model(rand_x, rand_y));
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [47:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,CLK, X, Y, Dout);
    end

endmodule
