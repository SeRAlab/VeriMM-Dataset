`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg rst;
    wire [23:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .audio_in(audio_in),
        .clk(clk),
        .rst(rst),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in = 16'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            audio_in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            audio_in = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'hFFFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hex Pattern 1234", test_num);
            reset_dut();
            audio_in = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h123400);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern AAAA", test_num);
            reset_dut();
            audio_in = 16'hAAAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'hAAAA00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 5555", test_num);
            reset_dut();
            audio_in = 16'h5555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h555500);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Set", test_num);
            reset_dut();
            audio_in = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LSB Set", test_num);
            reset_dut();
            audio_in = 16'h0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(24'h000100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [23:0] expected_audio_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,audio_in, clk, rst, audio_out);
    end

endmodule
