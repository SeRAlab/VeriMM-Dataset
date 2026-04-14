`timescale 1ns/1ps

module turbo_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] encoded_input;
    reg reset;
    reg valid;
    wire [7:0] decoded_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_decoder dut (
        .clk(clk),
        .encoded_input(encoded_input),
        .reset(reset),
        .valid(valid),
        .decoded_output(decoded_output),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            encoded_input = 8'h00;
            #20;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Input 8'h00 (All Zeros)", test_num);
            reset_dut();

            encoded_input = 8'h00;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Input 8'hFF (All Ones)", test_num);
            reset_dut();

            encoded_input = 8'hFF;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Input 8'hAA (Alternating 1010)", test_num);
            reset_dut();

            encoded_input = 8'hAA;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Input 8'h55 (Alternating 0101)", test_num);
            reset_dut();

            encoded_input = 8'h55;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Input 8'hA5", test_num);
            reset_dut();

            encoded_input = 8'hA5;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Input 8'hF0", test_num);
            reset_dut();

            encoded_input = 8'hF0;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(done == 1'b1);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_decoder Testbench");
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
        input [7:0] expected_decoded_output;
        input expected_done;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h, done=%b",
                         decoded_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h, done=%b",
                         expected_decoded_output, expected_done);
                $display("  Got:      decoded_output=%h, done=%b",
                         decoded_output, done);
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
        $dumpvars(0,clk, encoded_input, reset, valid, decoded_output, done);
    end

endmodule
