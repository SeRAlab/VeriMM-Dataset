`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg search_en_in;
    reg spec_kc_in;
    reg wave_kc_in;
    reg wave_wea_in;
    wire wavefft_state_out;
    wire wavefft_wea_out;
    wire wavegener_state_out;
    wire wavegener_wea_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .search_en_in(search_en_in),
        .spec_kc_in(spec_kc_in),
        .wave_kc_in(wave_kc_in),
        .wave_wea_in(wave_wea_in),
        .wavefft_state_out(wavefft_state_out),
        .wavefft_wea_out(wavefft_wea_out),
        .wavegener_state_out(wavegener_state_out),
        .wavegener_wea_out(wavegener_wea_out)
    );

    // Clock generation (10ns period)
    initial begin
        spec_kc_in = 0;
        forever #5 spec_kc_in = ~spec_kc_in;
    end

        task reset_dut;

        begin
            search_en_in = 0;
            wave_kc_in = 0;
            wave_wea_in = 1;
            force dut.wavegener_state_out = 1'b1;
            force dut.wavefft_state_out = 1'b1;
            #10;
            release dut.wavegener_state_out;
            release dut.wavefft_state_out;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial State Check", test_num);
            reset_dut();



            #1;




            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: wave_kc_in Toggling State", test_num);
            reset_dut();

            wave_kc_in = 1; #10;
            wave_kc_in = 0; #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: spec_kc_in Toggling State", test_num);
            reset_dut();

            wait_cycles(1);

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: search_en_in Override Asserted", test_num);
            reset_dut();
            search_en_in = 1;
            wait_cycles(1);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: wave_wea_in Masking Outputs", test_num);
            reset_dut();
            wave_wea_in = 0;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Double Toggle Parity", test_num);
            reset_dut();


            wave_kc_in = 1; #10; wave_kc_in = 0; #10;
            wave_kc_in = 1; #10; wave_kc_in = 0; #10;


            wait_cycles(2);


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
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
        input expected_wavefft_state_out;
        input expected_wavefft_wea_out;
        input expected_wavegener_state_out;
        input expected_wavegener_wea_out;
        begin
            if (expected_wavefft_state_out === (expected_wavefft_state_out ^ wavefft_state_out ^ expected_wavefft_state_out) &&
                expected_wavefft_wea_out === (expected_wavefft_wea_out ^ wavefft_wea_out ^ expected_wavefft_wea_out) &&
                expected_wavegener_state_out === (expected_wavegener_state_out ^ wavegener_state_out ^ expected_wavegener_state_out) &&
                expected_wavegener_wea_out === (expected_wavegener_wea_out ^ wavegener_wea_out ^ expected_wavegener_wea_out)) begin
                $display("PASS");
                $display("  Outputs: wavefft_state_out=%b, wavefft_wea_out=%b, wavegener_state_out=%b, wavegener_wea_out=%b",
                         wavefft_state_out, wavefft_wea_out, wavegener_state_out, wavegener_wea_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wavefft_state_out=%b, wavefft_wea_out=%b, wavegener_state_out=%b, wavegener_wea_out=%b",
                         expected_wavefft_state_out, expected_wavefft_wea_out, expected_wavegener_state_out, expected_wavegener_wea_out);
                $display("  Got:      wavefft_state_out=%b, wavefft_wea_out=%b, wavegener_state_out=%b, wavegener_wea_out=%b",
                         wavefft_state_out, wavefft_wea_out, wavegener_state_out, wavegener_wea_out);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,search_en_in, spec_kc_in, wave_kc_in, wave_wea_in, wavefft_state_out, wavefft_wea_out, wavegener_state_out, wavegener_wea_out);
    end

endmodule
