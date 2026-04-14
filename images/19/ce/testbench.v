`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg received_bit;
    reg reset;
    wire [1:0] decoded_bit;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bit(received_bit),
        .reset(reset),
        .decoded_bit(decoded_bit),
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
            received_bit = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: All-Zeros Sequence", test_num);
            reset_dut();


            repeat(8) begin
                received_bit = 0;
                @(posedge clk);
            end



            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: All-Ones Sequence", test_num);
            reset_dut();

            repeat(8) begin
                received_bit = 1;
                @(posedge clk);
            end


            #1 #1;
 check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Alternating 1010 Sequence", test_num);
            reset_dut();

            repeat(4) begin
                received_bit = 1; @(posedge clk);
                received_bit = 0; @(posedge clk);
            end


            #1 #1;
 check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Single Bit Impulse", test_num);
            reset_dut();

            received_bit = 1; @(posedge clk);
            repeat(7) begin
                received_bit = 0; @(posedge clk);
            end


            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Pattern 11001100", test_num);
            reset_dut();

            repeat(2) begin
                received_bit = 1; @(posedge clk);
                received_bit = 1; @(posedge clk);
                received_bit = 0; @(posedge clk);
                received_bit = 0; @(posedge clk);
            end

            #1 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [1:0] expected_decoded_bit;
        input expected_valid;
        begin
            if (expected_decoded_bit === (expected_decoded_bit ^ decoded_bit ^ expected_decoded_bit) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded_bit=%h, valid=%b",
                         decoded_bit, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bit=%h, valid=%b",
                         expected_decoded_bit, expected_valid);
                $display("  Got:      decoded_bit=%h, valid=%b",
                         decoded_bit, valid);
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
        $dumpvars(0,clk, received_bit, reset, decoded_bit, valid);
    end

endmodule
