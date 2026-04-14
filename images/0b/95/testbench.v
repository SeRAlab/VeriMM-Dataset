`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg clk;
    reg enable;
    wire [7:0] mixed_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .clk(clk),
        .enable(enable),
        .mixed_out(mixed_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            audio_in1 = 0;
            audio_in2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Equal mid-range values (100, 100)", test_num);
            audio_in1 = 8'd100;
            audio_in2 = 8'd100;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Minimum values (0, 0)", test_num);
            audio_in1 = 8'd0;
            audio_in2 = 8'd0;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (255, 255)", test_num);
            audio_in1 = 8'd255;
            audio_in2 = 8'd255;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Odd sum truncation (127, 128)", test_num);

            audio_in1 = 8'd127;
            audio_in2 = 8'd128;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Wide range (200, 10)", test_num);

            audio_in1 = 8'd200;
            audio_in2 = 8'd10;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd105);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Enable signal functionality (Disabled)", test_num);


            audio_in1 = 8'd50;
            audio_in2 = 8'd50;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;


            audio_in1 = 8'd200;
            audio_in2 = 8'd200;
            enable = 0;
            @(posedge clk);
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'd50);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Rapid input change (80, 20)", test_num);
            audio_in1 = 8'd80;
            audio_in2 = 8'd20;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50);
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
        input [7:0] expected_mixed_out;
        begin
            if (expected_mixed_out === (expected_mixed_out ^ mixed_out ^ expected_mixed_out)) begin
                $display("PASS");
                $display("  Outputs: mixed_out=%h",
                         mixed_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mixed_out=%h",
                         expected_mixed_out);
                $display("  Got:      mixed_out=%h",
                         mixed_out);
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
        $dumpvars(0,audio_in1, audio_in2, clk, enable, mixed_out);
    end

endmodule
