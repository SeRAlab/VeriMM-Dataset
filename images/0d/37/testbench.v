`timescale 1ns/1ps

module fft_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] imag_in;
    reg [15:0] real_in;
    reg rst;
    reg valid;
    wire done;
    wire [15:0] imag_out;
    wire [15:0] real_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_processor dut (
        .clk(clk),
        .imag_in(imag_in),
        .real_in(real_in),
        .rst(rst),
        .valid(valid),
        .done(done),
        .imag_out(imag_out),
        .real_out(real_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            real_in = 16'd0;
            imag_in = 16'd0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Impulse Response (x[0]=8)", test_num);
            reset_dut();


            @(posedge clk);
            valid = 1;
            real_in = 16'sd8; imag_in = 16'sd0; @(posedge clk);
            real_in = 16'sd0; imag_in = 16'sd0;
            repeat(7) @(posedge clk);
            valid = 0;


            wait(done === 1'b1);


            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking sample %0d:", i);
                #1;

                check_outputs(1'b1, 16'sd0, 16'sd8);
                @(posedge clk);
            end
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: DC Signal (All 1s)", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            real_in = 16'sd1; imag_in = 16'sd0;
            repeat(8) @(posedge clk);
            valid = 0;

            wait(done === 1'b1);

            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking sample %0d:", i);
                if (i == 0)
                    #1;

                    check_outputs(1'b1, 16'sd0, 16'sd8);
                else
                    #1;

                    check_outputs(1'b1, 16'sd0, 16'sd0);
                @(posedge clk);
            end
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Nyquist Signal (Alternating 1/-1)", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            for (i = 0; i < 8; i = i + 1) begin
                real_in = (i % 2 == 0) ? 16'sd1 : -16'sd1;
                imag_in = 16'sd0;
                @(posedge clk);
            end
            valid = 0;

            wait(done === 1'b1);

            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking sample %0d:", i);
                if (i == 4)
                    #1;

                    check_outputs(1'b1, 16'sd0, 16'sd8);
                else
                    #1;

                    check_outputs(1'b1, 16'sd0, 16'sd0);
                @(posedge clk);
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d: Zero Input", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            real_in = 16'sd0; imag_in = 16'sd0;
            repeat(8) @(posedge clk);
            valid = 0;

            wait(done === 1'b1);

            for (i = 0; i < 8; i = i + 1) begin
                $display("Checking sample %0d:", i);
                #1;

                check_outputs(1'b1, 16'sd0, 16'sd0);
                @(posedge clk);
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
        $display("fft_processor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_done;
        input [15:0] expected_imag_out;
        input [15:0] expected_real_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_imag_out === (expected_imag_out ^ imag_out ^ expected_imag_out) &&
                expected_real_out === (expected_real_out ^ real_out ^ expected_real_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, imag_out=%h, real_out=%h",
                         done, imag_out, real_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, imag_out=%h, real_out=%h",
                         expected_done, expected_imag_out, expected_real_out);
                $display("  Got:      done=%b, imag_out=%h, real_out=%h",
                         done, imag_out, real_out);
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
        $dumpvars(0,clk, imag_in, real_in, rst, valid, done, imag_out, real_out);
    end

endmodule
