`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg enable;
    reg [31:0] modulus;
    reg reset;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .modulus(modulus),
        .reset(reset),
        .cout(cout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reach terminal count with Modulus 4", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd4;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify cout is 0 before reaching Modulus 10", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd10;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify enable signal behavior", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd3;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            repeat (3) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify wraparound from terminal count back to 1", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd2;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;

            @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Small modulus (Mod 2) terminal check", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd2;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;
            @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Asynchronous reset mid-count", test_num);

            reset = 1;
            enable = 0;
            modulus = 32'd5;
            #15 reset = 0;

            @(posedge clk);
            enable = 1;
            repeat(3) @(posedge clk);

            reset = 1;
            #5;


            #1;



            check_outputs(1'b0);
            reset = 0;
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
        testcase006();
        
        
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
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b",
                         cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b",
                         expected_cout);
                $display("  Got:      cout=%b",
                         cout);
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

endmodule
