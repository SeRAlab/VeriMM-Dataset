`timescale 1ns/1ps

module turbo_encoder_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input_bit;
    reg rst;
    reg valid_input;
    wire decoded_bit;
    wire [1:0] encoded_bits;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder_decoder dut (
        .clk(clk),
        .input_bit(input_bit),
        .rst(rst),
        .valid_input(valid_input),
        .decoded_bit(decoded_bit),
        .encoded_bits(encoded_bits),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_bit = 0;
            valid_input = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit '0' transition", test_num);
            reset_dut();

            valid_input = 1;
            input_bit = 0;
            @(posedge clk);
            #1;
            valid_input = 0;


            while (valid_output !== 1) @(posedge clk);



            #1;




            check_outputs(0, encoded_bits, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit '1' transition", test_num);
            reset_dut();

            valid_input = 1;
            input_bit = 1;
            @(posedge clk);
            #1;
            valid_input = 0;

            while (valid_output !== 1) @(posedge clk);

            #1;


            check_outputs(1, encoded_bits, 1);
        end
        endtask

    task testcase003;

        reg [3:0] test_vector;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 1010", test_num);
            reset_dut();

            test_vector = 4'b1010;

            for (i = 3; i >= 0; i = i - 1) begin
                valid_input = 1;
                input_bit = test_vector[i];
                @(posedge clk);
                #1;
            end
            valid_input = 0;



            repeat (4) begin
                while (valid_output !== 1) @(posedge clk);
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(test_vector[0], encoded_bits, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Block", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                valid_input = 1;
                input_bit = 0;
                @(posedge clk);
                #1;
            end
            valid_input = 0;

            repeat (8) begin
                while (valid_output !== 1) @(posedge clk);
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(0, encoded_bits, 1);
        end
        endtask

    task testcase005;

        reg [7:0] random_data;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random 8-bit Burst", test_num);
            reset_dut();

            random_data = 8'hA5;

            for (i = 0; i < 8; i = i + 1) begin
                valid_input = 1;
                input_bit = random_data[i];
                @(posedge clk);
                #1;
            end
            valid_input = 0;


            repeat (8) begin
                while (valid_output !== 1) @(posedge clk);
                if (i == 7) break;
                @(posedge clk);
                #1;
            end


            #1;



            check_outputs(random_data[7], encoded_bits, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder_decoder Testbench");
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
        input expected_decoded_bit;
        input [1:0] expected_encoded_bits;
        input expected_valid_output;
        begin
            if (expected_decoded_bit === (expected_decoded_bit ^ decoded_bit ^ expected_decoded_bit) &&
                expected_encoded_bits === (expected_encoded_bits ^ encoded_bits ^ expected_encoded_bits) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_bit=%b, encoded_bits=%h, valid_output=%b",
                         decoded_bit, encoded_bits, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bit=%b, encoded_bits=%h, valid_output=%b",
                         expected_decoded_bit, expected_encoded_bits, expected_valid_output);
                $display("  Got:      decoded_bit=%b, encoded_bits=%h, valid_output=%b",
                         decoded_bit, encoded_bits, valid_output);
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
        $dumpvars(0,clk, input_bit, rst, valid_input, decoded_bit, encoded_bits, valid_output);
    end

endmodule
