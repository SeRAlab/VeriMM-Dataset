`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio_data;
    wire [7:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .audio_data(audio_data),
        .led_out(led_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 0", test_num);
        audio_data = 8'd0;
        #1;

        check_outputs(8'b0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 32 (Boundary)", test_num);
        audio_data = 8'd32;
        #1;

        check_outputs(8'b0000_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 33 (>32)", test_num);
        audio_data = 8'd33;
        #1;

        check_outputs(8'b0000_0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 65 (>64)", test_num);
        audio_data = 8'd65;
        #1;

        check_outputs(8'b0000_0011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 97 (>96)", test_num);
        audio_data = 8'd97;
        #1;

        check_outputs(8'b0000_0111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 129 (>128)", test_num);
        audio_data = 8'd129;
        #1;

        check_outputs(8'b0000_1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 151 (>150)", test_num);
        audio_data = 8'd151;
        #1;

        check_outputs(8'b0001_1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 183 (>182)", test_num);
        audio_data = 8'd183;
        #1;

        check_outputs(8'b0011_1111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 215 (>214)", test_num);
        audio_data = 8'd215;
        #1;

        check_outputs(8'b0111_1111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 249 (!= 250)", test_num);
        audio_data = 8'd249;
        #1;

        check_outputs(8'b0111_1111);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 250 (Special Case)", test_num);
        audio_data = 8'd250;
        #1;

        check_outputs(8'b1111_1111);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 251 (!= 250)", test_num);
        audio_data = 8'd251;
        #1;

        check_outputs(8'b0111_1111);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing audio_data = 255 (Max)", test_num);
        audio_data = 8'd255;
        #1;

        check_outputs(8'b0111_1111);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [7:0] expected_led_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: led_out=%h",
                         led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_out=%h",
                         expected_led_out);
                $display("  Got:      led_out=%h",
                         led_out);
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
