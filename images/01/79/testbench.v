`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg reset;
    reg start;
    wire [127:0] output_hmac;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .reset(reset),
        .start(start),
        .output_hmac(output_hmac),
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
            key = 128'h0;
            message = 128'h0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!valid) @(posedge clk);

            #1;


            check_outputs(128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones Message", test_num);
            reset_dut();
            key = 128'hFEDCBA9876543210FEDCBA9876543210;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(128'h95959595959595959595959595959595, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Message equals 0x6A... (Expect 0)", test_num);
            reset_dut();
            key = 128'h12345678123456781234567812345678;
            message = 128'h6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(128'h00000000000000000000000000000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Patterns", test_num);
            reset_dut();
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);

            #1;


            check_outputs(128'h3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f3f, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Incremental Hex Message", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0123456789ABCDEF0123456789ABCDEF;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!valid) @(posedge clk);



            #1;




            check_outputs(128'h6b492f0de3c1a7856b492f0de3c1a785, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input [127:0] expected_output_hmac;
        input expected_valid;
        begin
            if (expected_output_hmac === (expected_output_hmac ^ output_hmac ^ expected_output_hmac) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_hmac=%h, valid=%b",
                         output_hmac, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_hmac=%h, valid=%b",
                         expected_output_hmac, expected_valid);
                $display("  Got:      output_hmac=%h, valid=%b",
                         output_hmac, valid);
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
        $dumpvars(0,clk, key, message, reset, start, output_hmac, valid);
    end

endmodule
