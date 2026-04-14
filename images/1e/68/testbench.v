`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .start(start),
        .done(done),
        .hash(hash)
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
            message = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero message block", test_num);
            reset_dut();

            message = 512'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);



            #1;




            check_outputs(1'b1, 128'h70ad63546702758f4a3952f9c8a1496b);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-ones message block", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 128'hd9991253019808a385202888e250109a);
            @(posedge clk);
        end
        endtask

    task testcase003;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental 32-bit pattern", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                pattern[i*32 +: 32] = i;
            end

            message = pattern;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 128'h6d90066928e08542978082987a07747e);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bit pattern (0xAAAAAAAA)", test_num);
            reset_dut();

            message = {16{32'hAAAAAAAA}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);


            #1;



            check_outputs(1'b1, 128'h3317730894086975298511634567228a);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Repeated Start Check", test_num);


            reset_dut();
            message = 512'h12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0_12345678_9ABCDEF0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);


            @(posedge clk);
            message = 512'h0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);


            #1;



            check_outputs(1'b1, 128'h70ad63546702758f4a3952f9c8a1496b);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input expected_done;
        input [127:0] expected_hash;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash=%h",
                         done, hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash=%h",
                         expected_done, expected_hash);
                $display("  Got:      done=%b, hash=%h",
                         done, hash);
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
        $dumpvars(0,clk, message, reset, start, done, hash);
    end

endmodule
