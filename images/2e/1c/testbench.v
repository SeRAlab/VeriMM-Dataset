`timescale 1ns/1ps

module bst_insert_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] new_value;
    reg [7:0] root;
    wire [7:0] updated_root;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bst_insert dut (
        .new_value(new_value),
        .root(root),
        .updated_root(updated_root)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Insert into empty tree (root=0)", test_num);
        root = 8'd0;
        new_value = 8'd50;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Insert smaller value into existing tree", test_num);
        root = 8'd50;
        new_value = 8'd25;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Insert larger value into existing tree", test_num);
        root = 8'd50;
        new_value = 8'd75;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Insert into empty tree (new_value=0)", test_num);
        root = 8'd0;
        new_value = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Insert value equal to root", test_num);
        root = 8'd100;
        new_value = 8'd100;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Insert into empty tree (max value)", test_num);
        root = 8'd0;
        new_value = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bst_insert Testbench");
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
        input [7:0] expected_updated_root;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_root === (expected_updated_root ^ updated_root ^ expected_updated_root)) begin
                $display("PASS");
                $display("  Outputs: updated_root=%h",
                         updated_root);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_root=%h",
                         expected_updated_root);
                $display("  Got:      updated_root=%h",
                         updated_root);
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
