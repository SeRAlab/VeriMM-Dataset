`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] data_in;
    wire [39:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reverse sorted input", test_num);
            data_in = {8'd50, 8'd40, 8'd30, 8'd20, 8'd10};
            #1;

            check_outputs({8'd10, 8'd20, 8'd30, 8'd40, 8'd50});
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Already sorted input", test_num);
            data_in = {8'd5, 8'd15, 8'd25, 8'd35, 8'd45};
            #1;

            check_outputs({8'd5, 8'd15, 8'd25, 8'd35, 8'd45});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Random unsorted input", test_num);
            data_in = {8'd12, 8'd255, 8'd0, 8'd88, 8'd42};
            #1;

            check_outputs({8'd0, 8'd12, 8'd42, 8'd88, 8'd255});
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Duplicate values", test_num);
            data_in = {8'd7, 8'd2, 8'd7, 8'd1, 8'd2};
            #1;

            check_outputs({8'd1, 8'd2, 8'd2, 8'd7, 8'd7});
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All values identical", test_num);
            data_in = {8'd100, 8'd100, 8'd100, 8'd100, 8'd100};
            #1;

            check_outputs({8'd100, 8'd100, 8'd100, 8'd100, 8'd100});
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Min element at the end", test_num);
            data_in = {8'd20, 8'd30, 8'd40, 8'd50, 8'd5};
            #1;

            check_outputs({8'd5, 8'd20, 8'd30, 8'd40, 8'd50});
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Max and Min possible values", test_num);
            data_in = {8'hFF, 8'h00, 8'hFF, 8'h00, 8'hAA};
            #1;

            check_outputs({8'h00, 8'h00, 8'hAA, 8'hFF, 8'hFF});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [39:0] expected_data_out;
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
