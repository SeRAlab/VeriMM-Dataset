`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg rst;
    reg valid_in;
    wire [63:0] modulated_signal;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .modulated_signal(modulated_signal),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: System Reset and Idle State");
            test_num = test_num + 1;
            reset_dut();

            repeat (5) @(posedge clk);


            #1;



            check_outputs(64'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Frame Processing with Zero Input");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            valid_in = 1;
            data_in = 64'h0000_0000_0000_0000;
            @(posedge clk);
            valid_in = 0;



            wait(valid_out == 1);
            @(posedge clk);


            #1;



            check_outputs(64'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Frame Processing with Constant High Data");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            valid_in = 1;
            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            valid_in = 0;


            wait(valid_out == 1);
            @(posedge clk);




            #1;





            check_outputs(modulated_signal, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Back-to-Back Frame Processing");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 64'h1234_5678_9ABC_DEF0;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);


            valid_in = 1;
            data_in = 64'hFEDC_BA98_7654_3210;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);

            #1;


            check_outputs(modulated_signal, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input Pulse Stability");
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            valid_in = 1;
            data_in = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out == 1);
            @(posedge clk);


            #1;



            check_outputs(modulated_signal, 1'b1);


            repeat (2) @(posedge clk);
            if (valid_out == 0) begin
                $display("PASS: Output valid signal de-asserted correctly.");
            end else begin
                $display("FAIL: Output valid signal stuck high.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [63:0] expected_modulated_signal;
        input expected_valid_out;
        begin
            if (expected_modulated_signal === (expected_modulated_signal ^ modulated_signal ^ expected_modulated_signal) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: modulated_signal=%h, valid_out=%b",
                         modulated_signal, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: modulated_signal=%h, valid_out=%b",
                         expected_modulated_signal, expected_valid_out);
                $display("  Got:      modulated_signal=%h, valid_out=%b",
                         modulated_signal, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, modulated_signal, valid_out);
    end

endmodule
