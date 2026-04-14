`timescale 1ns/1ps

module LZW_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_char;
    reg reset;
    reg start;
    wire [7:0] output_code;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Encoder dut (
        .clk(clk),
        .input_char(input_char),
        .reset(reset),
        .start(start),
        .output_code(output_code),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            input_char = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Basic Single Character Encoding", test_num);


            input_char = 4'h4;
            start = 1;
            @(posedge clk);


            input_char = 4'h5;
            start = 1;
            @(posedge clk);

            start = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h04, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Multiple Character Sequence", test_num);


            input_char = 4'hA; start = 1; @(posedge clk);
            input_char = 4'hB; start = 1; @(posedge clk);
            input_char = 4'hC; start = 1; @(posedge clk);

            start = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'h0B, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Repeated Character Sequence", test_num);



            input_char = 4'h1; start = 1; @(posedge clk);
            input_char = 4'h1; start = 1; @(posedge clk);
            input_char = 4'h2; start = 1; @(posedge clk);

            start = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase%03d: Reset Mid-Operation", test_num);

            input_char = 4'hF; start = 1; @(posedge clk);
            input_char = 4'hE; start = 1; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            start = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Encoder Testbench");
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
        input [7:0] expected_output_code;
        input expected_valid;
        begin
            if (expected_output_code === (expected_output_code ^ output_code ^ expected_output_code) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_code=%h, valid=%b",
                         output_code, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_code=%h, valid=%b",
                         expected_output_code, expected_valid);
                $display("  Got:      output_code=%h, valid=%b",
                         output_code, valid);
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
        $dumpvars(0,clk, input_char, reset, start, output_code, valid);
    end

endmodule
