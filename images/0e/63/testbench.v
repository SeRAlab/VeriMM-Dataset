`timescale 1ns/1ps

module audio_compression_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio_in;
    wire [2:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compression dut (
        .audio_in(audio_in),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = 1;
        audio_in = 5'b00000;
        $display("Test %0d: All Zeros (5'b00000)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        audio_in = 5'b11111;
        $display("Test %0d: All Ones (5'b11111)", test_num);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        audio_in = 5'b10101;
        $display("Test %0d: Specification Example (5'b10101)", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        audio_in = 5'b01010;
        $display("Test %0d: Alternating Bits (5'b01010)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        audio_in = 5'b11011;
        $display("Test %0d: Input with lower bits set (5'b11011)", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        audio_in = 5'b11000;
        $display("Test %0d: Input with lower bits cleared (5'b11000)", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compression Testbench");
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
        input [2:0] expected_audio_out;
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
