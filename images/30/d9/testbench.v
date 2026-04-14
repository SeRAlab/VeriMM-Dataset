`timescale 1ns/1ps

module binary_search_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [2:0] index;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_search dut (
        .data_in(data_in),
        .index(index),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Writing and Reading from Index 0 (Lower Bound)", test_num);

        write_enable = 1;
        index = 3'd0;
        data_in = 8'h0A;
        #10;
        write_enable = 0;
        #5;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Writing and Reading from Index 7 (Upper Bound)", test_num);
        write_enable = 1;
        index = 3'd7;
        data_in = 8'hF0;
        #10;
        write_enable = 0;
        #5;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Writing and Reading from Middle Index 3", test_num);
        write_enable = 1;
        index = 3'd3;
        data_in = 8'h55;
        #10;
        write_enable = 0;
        #5;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verifying Read Mode Stability (WE=0)", test_num);

        write_enable = 1;
        index = 3'd4;
        data_in = 8'hAA;
        #10;

        write_enable = 0;
        data_in = 8'hFF;
        index = 3'd4;
        #10;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwriting an existing entry", test_num);

        write_enable = 1;
        index = 3'd2;
        data_in = 8'h12;
        #10;

        data_in = 8'h34;
        #10;
        write_enable = 0;
        #5;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify sequence storage for sorted array", test_num);

        write_enable = 1;
        index = 3'd0; data_in = 8'h01; #10;
        index = 3'd1; data_in = 8'h05; #10;
        index = 3'd2; data_in = 8'h10; #10;
        index = 3'd3; data_in = 8'h15; #10;
        index = 3'd4; data_in = 8'h20; #10;
        index = 3'd5; data_in = 8'h25; #10;
        index = 3'd6; data_in = 8'h30; #10;
        index = 3'd7; data_in = 8'h35; #10;


        write_enable = 0;
        index = 3'd5;
        #10;
        #1;

        check_outputs(8'h25);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify index 1 from previous sequence", test_num);
        write_enable = 0;
        index = 3'd1;
        #10;
        #1;

        check_outputs(8'h05);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_search Testbench");
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
        input [7:0] expected_data_out;
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
