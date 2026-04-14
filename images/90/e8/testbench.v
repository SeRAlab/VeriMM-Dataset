`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] audio_in_data;
    reg audio_in_valid;
    reg audio_out_ready;
    wire audio_in_ready;
    wire [31:0] audio_out_data;
    wire audio_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_in_data(audio_in_data),
        .audio_in_valid(audio_in_valid),
        .audio_out_ready(audio_out_ready),
        .audio_in_ready(audio_in_ready),
        .audio_out_data(audio_out_data),
        .audio_out_valid(audio_out_valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Successful Handshake (Both Valid and Ready)", test_num);

        audio_in_data = 32'h12345678;
        audio_in_valid = 1;
        audio_out_ready = 1;


        #1;



        check_outputs(1'b1, 32'h12345678, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sink Not Ready (Stall)", test_num);

        audio_in_data = 32'hAAAAAAAA;
        audio_in_valid = 1;
        audio_out_ready = 0;





        #1;






        check_outputs(1'b0, 32'hAAAAAAAA, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Source Not Valid (Idle)", test_num);

        audio_in_data = 32'h55555555;
        audio_in_valid = 0;
        audio_out_ready = 1;




        #1;





        check_outputs(1'b0, 32'h55555555, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Neither Valid nor Ready", test_num);

        audio_in_data = 32'h00000000;
        audio_in_valid = 0;
        audio_out_ready = 0;


        #1;



        check_outputs(1'b0, 32'h00000000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Data Value Handshake", test_num);

        audio_in_data = 32'hFFFFFFFF;
        audio_in_valid = 1;
        audio_out_ready = 1;


        #1;



        check_outputs(1'b1, 32'hFFFFFFFF, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Data Pattern", test_num);

        audio_in_data = 32'hC0DEFEED;
        audio_in_valid = 1;
        audio_out_ready = 1;

        #1;


        check_outputs(1'b1, 32'hC0DEFEED, 1'b1);
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
        input expected_audio_in_ready;
        input [31:0] expected_audio_out_data;
        input expected_audio_out_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_audio_in_ready === (expected_audio_in_ready ^ audio_in_ready ^ expected_audio_in_ready) &&
                expected_audio_out_data === (expected_audio_out_data ^ audio_out_data ^ expected_audio_out_data) &&
                expected_audio_out_valid === (expected_audio_out_valid ^ audio_out_valid ^ expected_audio_out_valid)) begin
                $display("PASS");
                $display("  Outputs: audio_in_ready=%b, audio_out_data=%h, audio_out_valid=%b",
                         audio_in_ready, audio_out_data, audio_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_in_ready=%b, audio_out_data=%h, audio_out_valid=%b",
                         expected_audio_in_ready, expected_audio_out_data, expected_audio_out_valid);
                $display("  Got:      audio_in_ready=%b, audio_out_data=%h, audio_out_valid=%b",
                         audio_in_ready, audio_out_data, audio_out_valid);
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
