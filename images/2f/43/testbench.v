`timescale 1ns/1ps

module audio_mux_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio_in0;
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg [7:0] audio_in3;
    reg [1:0] select;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mux dut (
        .audio_in0(audio_in0),
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .audio_in3(audio_in3),
        .select(select),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Selecting Input 0 (0xAA)", test_num);
        audio_in0 = 8'hAA; audio_in1 = 8'h11; audio_in2 = 8'h22; audio_in3 = 8'h33;
        select = 2'b00;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Selecting Input 1 (0x55)", test_num);
        audio_in0 = 8'hAA; audio_in1 = 8'h55; audio_in2 = 8'h22; audio_in3 = 8'h33;
        select = 2'b01;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Selecting Input 2 (0xF0)", test_num);
        audio_in0 = 8'hAA; audio_in1 = 8'h55; audio_in2 = 8'hF0; audio_in3 = 8'h33;
        select = 2'b10;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Selecting Input 3 (0x0F)", test_num);
        audio_in0 = 8'hAA; audio_in1 = 8'h55; audio_in2 = 8'hF0; audio_in3 = 8'h0F;
        select = 2'b11;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All inputs 0x00, Select 1", test_num);
        audio_in0 = 8'h00; audio_in1 = 8'h00; audio_in2 = 8'h00; audio_in3 = 8'h00;
        select = 2'b01;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: All inputs 0xFF, Select 2", test_num);
        audio_in0 = 8'hFF; audio_in1 = 8'hFF; audio_in2 = 8'hFF; audio_in3 = 8'hFF;
        select = 2'b10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Changing Input 3 value while selected", test_num);
        select = 2'b11;
        audio_in3 = 8'hDE;
        #5;
        audio_in3 = 8'hAD;
        #1;

        check_outputs(8'hAD);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mux Testbench");
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
        input [7:0] expected_audio_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h",
                         audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h",
                         expected_audio_out);
                $display("  Got:      audio_out=%h",
                         audio_out);
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
