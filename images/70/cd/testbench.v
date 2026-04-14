`timescale 1ns/1ps

module bin2onehot_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] bin_in;
    wire [7:0] onehot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2onehot dut (
        .bin_in(bin_in),
        .onehot_out(onehot_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Testing binary input 3'b000", test_num);
        bin_in = 3'b000;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Testing binary input 3'b001", test_num);
        bin_in = 3'b001;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Testing binary input 3'b010", test_num);
        bin_in = 3'b010;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Testing binary input 3'b011", test_num);
        bin_in = 3'b011;
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Testing binary input 3'b100", test_num);
        bin_in = 3'b100;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Testing binary input 3'b101", test_num);
        bin_in = 3'b101;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Testing binary input 3'b110", test_num);
        bin_in = 3'b110;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Testing binary input 3'b111", test_num);
        bin_in = 3'b111;
        #1;

        check_outputs(8'h80);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2onehot Testbench");
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
        input [7:0] expected_onehot_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_onehot_out === (expected_onehot_out ^ onehot_out ^ expected_onehot_out)) begin
                $display("PASS");
                $display("  Outputs: onehot_out=%h",
                         onehot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: onehot_out=%h",
                         expected_onehot_out);
                $display("  Got:      onehot_out=%h",
                         onehot_out);
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
