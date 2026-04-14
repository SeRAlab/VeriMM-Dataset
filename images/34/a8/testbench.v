`timescale 1ns/1ps

module audio_mux_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in1;
    reg [15:0] audio_in2;
    reg select;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mux dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .select(select),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 1 (Normal Value)", test_num);
            audio_in1 = 16'hAAAA;
            audio_in2 = 16'h5555;
            select = 1'b0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 2 (Normal Value)", test_num);
            audio_in1 = 16'hAAAA;
            audio_in2 = 16'h5555;
            select = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 1 (All Zeros)", test_num);
            audio_in1 = 16'h0000;
            audio_in2 = 16'hFFFF;
            select = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 2 (All Ones)", test_num);
            audio_in1 = 16'h0000;
            audio_in2 = 16'hFFFF;
            select = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 1 (Arbitrary Data)", test_num);
            audio_in1 = 16'h1234;
            audio_in2 = 16'h89AB;
            select = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 2 (Arbitrary Data)", test_num);
            audio_in1 = 16'h1234;
            audio_in2 = 16'h89AB;
            select = 1'b1;
            #1;

            check_outputs(16'h89AB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Input 1", test_num);
            audio_in1 = 16'hC3C3;
            audio_in2 = 16'h3C3C;
            select = 1'b0;
            #1;

            check_outputs(16'hC3C3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Input 2", test_num);
            audio_in1 = 16'hC3C3;
            audio_in2 = 16'h3C3C;
            select = 1'b1;
            #1;

            check_outputs(16'h3C3C);
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
        input [15:0] expected_audio_out;
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
