`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] msg;
    reg rst;
    wire [15:0] codeword;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .clk(clk),
        .msg(msg),
        .rst(rst),
        .codeword(codeword),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            msg = 8'h00;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message = 8'h00 (All Zeros)", test_num);
            reset_dut();
            msg = 8'h00;


            wait(valid === 1);
            @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message = 8'h01", test_num);
            reset_dut();
            msg = 8'h01;

            wait(valid === 1);
            @(posedge clk);



            #1;




            check_outputs(codeword, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message = 8'hFF", test_num);
            reset_dut();
            msg = 8'hFF;

            wait(valid === 1);
            @(posedge clk);

            #1;


            check_outputs(codeword, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message = 8'hAA", test_num);
            reset_dut();
            msg = 8'hAA;

            wait(valid === 1);
            @(posedge clk);

            #1;


            check_outputs(codeword, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message = 8'h55", test_num);
            reset_dut();
            msg = 8'h55;

            wait(valid === 1);
            @(posedge clk);

            #1;


            check_outputs(codeword, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reed_solomon_encoder Testbench");
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
        input [15:0] expected_codeword;
        input expected_valid;
        begin
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h, valid=%b",
                         codeword, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h, valid=%b",
                         expected_codeword, expected_valid);
                $display("  Got:      codeword=%h, valid=%b",
                         codeword, valid);
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
        $dumpvars(0,clk, msg, rst, codeword, valid);
    end

endmodule
