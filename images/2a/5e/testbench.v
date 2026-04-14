`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] message;
    reg rst;
    reg start;
    wire done;
    wire [55:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .encoded(encoded)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: All Zeros Message", test_num);
            reset_dut();

            message = 32'h0000_0000;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 56'h00000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Sequential Message [01, 02, 03, 04]", test_num);
            reset_dut();

            message = 32'h0102_0304;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(4) @(posedge clk);



            #1;




            check_outputs(1'b1, 56'h010203047F16AE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: All Ones Message", test_num);
            reset_dut();

            message = 32'hFFFF_FFFF;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 56'hFFFFFFFF901932);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %04d: Timing/Latency Check", test_num);
            reset_dut();

            message = 32'hA5A5_A5A5;
            start = 1;
            @(posedge clk);
            start = 0;


            @(posedge clk);
            if (done === 1'b0) begin
                $display("  Cycle 2: Done is low (Correct)");
            end else begin
                $display("  Cycle 2: Done is high (Incorrect)");
                fail_count = fail_count + 1;
            end


            repeat(2) @(posedge clk);
            @(posedge clk);

            if (done === 1'b1) begin
                $display("  Cycle 4: Done is high (Correct)");
                pass_count = pass_count + 1;
            end else begin
                $display("  Cycle 4: Done is low (Incorrect)");
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
        $display("rs_encoder Testbench");
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
        input [55:0] expected_encoded;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: done=%b, encoded=%h",
                         done, encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, encoded=%h",
                         expected_done, expected_encoded);
                $display("  Got:      done=%b, encoded=%h",
                         done, encoded);
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
        $dumpvars(0,clk, message, rst, start, done, encoded);
    end

endmodule
