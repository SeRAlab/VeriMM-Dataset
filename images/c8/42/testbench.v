`timescale 1ns/1ps

module mux2_1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input1;
    reg [7:0] input2;
    reg select;
    wire [7:0] selected_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2_1 dut (
        .input1(input1),
        .input2(input2),
        .select(select),
        .selected_out(selected_out)
    );
    task testcase001;

        begin
            test_num = 1;
            input1 = 8'hAA;
            input2 = 8'h55;
            select = 0;
            #100;
            $display("Testcase %0d: Selecting Input 1 (8'hAA)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input1 = 8'hAA;
            input2 = 8'h55;
            select = 1;
            #100;
            $display("Testcase %0d: Selecting Input 2 (8'h55)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input1 = 8'hFF;
            input2 = 8'h00;
            select = 0;
            #100;
            $display("Testcase %0d: Selecting Input 1 (All Ones)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input1 = 8'hFF;
            input2 = 8'h00;
            select = 1;
            #100;
            $display("Testcase %0d: Selecting Input 2 (All Zeros)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input1 = 8'h12;
            input2 = 8'h34;
            select = 0;
            #100;

            input1 = 8'h56;
            #100;
            $display("Testcase %0d: Dynamic data change on selected input1", test_num);
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input1 = 8'hA5;
            input2 = 8'h5A;
            select = 1;
            #100;

            select = 0;
            #100;
            $display("Testcase %0d: Toggling select from 1 to 0", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2_1 Testbench");
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
        input [7:0] expected_selected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selected_out === (expected_selected_out ^ selected_out ^ expected_selected_out)) begin
                $display("PASS");
                $display("  Outputs: selected_out=%h",
                         selected_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected_out=%h",
                         expected_selected_out);
                $display("  Got:      selected_out=%h",
                         selected_out);
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
