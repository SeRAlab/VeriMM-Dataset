`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg [3:0] data_in;
    reg dir;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .data_in(data_in),
        .dir(dir),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 0; B = 0; C = 0; data_in = 4'b1011; dir = 0;
            $display("Testcase %0d: Input 1011, ABC=000 (Shift 0), Dir=0", test_num);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 0; B = 0; C = 1; data_in = 4'b1000; dir = 0;
            $display("Testcase %0d: Input 1000, ABC=001, Dir=0 (Left)", test_num);



            #1;




            check_outputs(data_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 0; B = 0; C = 1; data_in = 4'b0001; dir = 1;
            $display("Testcase %0d: Input 0001, ABC=001, Dir=1 (Right)", test_num);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 0; B = 1; C = 0; data_in = 4'b1111; dir = 0;
            $display("Testcase %0d: Input 1111, ABC=010, Dir=0", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 1; B = 1; C = 1; data_in = 4'b0000; dir = 1;
            $display("Testcase %0d: Input 0000, ABC=111, Dir=1", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 0; B = 1; C = 0; data_in = 4'b0011; dir = 0;
            $display("Testcase %0d: Input 0011, ABC=010 (Shift 2), Dir=0", test_num);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 1; B = 1; C = 1; data_in = 4'b0101; dir = 0;
            $display("Testcase %0d: Input 0101, ABC=111, Dir=0", test_num);
            #1;

            check_outputs(data_out);
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
        testcase007();
        
        
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
