`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg [1:0] control;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .control(control),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Audio 1", test_num);
        audio_in1 = 8'hA5;
        audio_in2 = 8'h3C;
        control = 2'b00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Audio 2", test_num);
        audio_in1 = 8'hA5;
        audio_in2 = 8'h3C;
        control = 2'b01;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Average (Even Sum)", test_num);
        audio_in1 = 8'd100;
        audio_in2 = 8'd200;
        control = 2'b10;

        #1;


        check_outputs(8'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Average (Odd Sum)", test_num);
        audio_in1 = 8'd10;
        audio_in2 = 8'd11;
        control = 2'b10;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Average (Large Values)", test_num);
        audio_in1 = 8'd255;
        audio_in2 = 8'd255;
        control = 2'b10;

        #1;


        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max (1 > 2)", test_num);
        audio_in1 = 8'd240;
        audio_in2 = 8'd120;
        control = 2'b11;
        #1;

        check_outputs(8'd240);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max (2 > 1)", test_num);
        audio_in1 = 8'd50;
        audio_in2 = 8'd210;
        control = 2'b11;
        #1;

        check_outputs(8'd210);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Max (Equal)", test_num);
        audio_in1 = 8'd128;
        audio_in2 = 8'd128;
        control = 2'b11;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Inputs Average", test_num);
        audio_in1 = 8'd0;
        audio_in2 = 8'd0;
        control = 2'b10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Average Max/Min", test_num);
        audio_in1 = 8'd255;
        audio_in2 = 8'd0;
        control = 2'b10;

        #1;


        check_outputs(8'd127);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
