`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg [2:0] phase;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .data_in(data_in),
        .phase(phase),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Phase 0 - Identity (No shift)");
        data_in = 8'hA5;
        phase = 3'd0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Phase 1 - Single bit right rotate");
        data_in = 8'h01;
        phase = 3'd1;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Phase 2 - Two bit right rotate");
        data_in = 8'h80;
        phase = 3'd2;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Phase 3 - Three bit right rotate");
        data_in = 8'h11;
        phase = 3'd3;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Phase 4 - Four bit right rotate (Nibble Swap)");
        data_in = 8'hF0;
        phase = 3'd4;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Phase 5 - Five bit right rotate");
        data_in = 8'h55;
        phase = 3'd5;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Phase 6 - Six bit right rotate");
        data_in = 8'h0F;
        phase = 3'd6;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Phase 7 - Seven bit right rotate (Wrap around)");
        data_in = 8'h01;
        phase = 3'd7;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: All bits set");
        data_in = 8'hFF;
        phase = 3'd4;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: All bits zero");
        data_in = 8'h00;
        phase = 3'd2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
