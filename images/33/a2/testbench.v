`timescale 1ns/1ps

module png_filter_selector_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] filter_type;
    wire [2:0] filter_code;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_filter_selector dut (
        .filter_type(filter_type),
        .filter_code(filter_code),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Filter Type 0 (None)", test_num);
        filter_type = 3'd0;
        #1;

        check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Filter Type 1 (Sub)", test_num);
        filter_type = 3'd1;
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Filter Type 2 (Up)", test_num);
        filter_type = 3'd2;
        #1;

        check_outputs(3'd2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Filter Type 3 (Average)", test_num);
        filter_type = 3'd3;
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Filter Type 4 (Paeth)", test_num);
        filter_type = 3'd4;
        #1;

        check_outputs(3'd4, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Filter Type 5 (Invalid)", test_num);
        filter_type = 3'd5;




        #1;





        check_outputs(filter_code, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest %0d: Filter Type 6 (Invalid)", test_num);
        filter_type = 3'd6;
        #1;

        check_outputs(filter_code, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest %0d: Filter Type 7 (Invalid)", test_num);
        filter_type = 3'd7;
        #1;

        check_outputs(filter_code, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_filter_selector Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_filter_code;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filter_code === (expected_filter_code ^ filter_code ^ expected_filter_code) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: filter_code=%h, valid=%b",
                         filter_code, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filter_code=%h, valid=%b",
                         expected_filter_code, expected_valid);
                $display("  Got:      filter_code=%h, valid=%b",
                         filter_code, valid);
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
