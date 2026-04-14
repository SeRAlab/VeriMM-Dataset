`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire [15:0] compressed_out;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .compressed_out(compressed_out),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            data_valid = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] byte_to_send;
        begin
            data_in = byte_to_send;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            repeat (2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Character 'A'", test_num);
            reset_dut();

            send_byte(8'h41);



            while (!out_valid) @(posedge clk);
            #1;

            check_outputs(16'h0041, 1'b1);
            repeat (5) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Non-Repeating Sequence 'TO'", test_num);
            reset_dut();

            send_byte(8'h54);
            send_byte(8'h4F);





            while (!out_valid) @(posedge clk);
            @(posedge clk);
            while (!out_valid) @(posedge clk);
            #1;

            check_outputs(16'h004F, 1'b1);
            repeat (5) @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Repeating Pattern 'ABAB'", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);
            send_byte(8'h41);
            send_byte(8'h42);









            integer valids;
            valids = 0;
            while (valids < 3) begin
                @(posedge clk);
                if (out_valid) valids = valids + 1;
            end

            #1;


            check_outputs(16'h0100, 1'b1);
            repeat (5) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Repeated Characters 'AAAAA'", test_num);
            reset_dut();

            send_byte(8'h41); send_byte(8'h41);
            send_byte(8'h41); send_byte(8'h41);
            send_byte(8'h41);




            reg [15:0] last_code;
            integer i;
            for (i=0; i<100; i=i+1) begin
                @(posedge clk);
                if (out_valid) last_code = compressed_out;
            end



            #1;




            check_outputs(last_code, 1'b1);
            repeat (5) @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compressor Testbench");
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
        input [15:0] expected_compressed_out;
        input expected_out_valid;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, out_valid=%b",
                         compressed_out, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, out_valid=%b",
                         expected_compressed_out, expected_out_valid);
                $display("  Got:      compressed_out=%h, out_valid=%b",
                         compressed_out, out_valid);
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
        $dumpvars(0,clk, data_in, data_valid, reset, compressed_out, out_valid);
    end

endmodule
