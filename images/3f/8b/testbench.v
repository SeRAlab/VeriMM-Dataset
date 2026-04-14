`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire done;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
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
            rst = 1;
            start = 0;
            message = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512 bits of zeros", test_num);
            reset_dut();

            message = 512'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512 bits of ones (0xFF...FF)", test_num);
            reset_dut();

            message = {64{8'hFF}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hcf003730302ed191a349c20a444f07a56114a82260656a4270c5e73b22f0f443);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512 bits of ASCII 'a'", test_num);
            reset_dut();

            message = {64{8'h61}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h81a029285038084a44f808752e5055b89ed2000572621415dfb034032483f982);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: 512 bits of alternating pattern (0xAA)", test_num);
            reset_dut();

            message = {64{8'hAA}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hb36484364024479e3907147b4695b7747e9282365e648c89420067341399e504);
        end
        endtask

    task testcase005;

        reg [511:0] msg_buffer;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental byte sequence (0x00 to 0x3F)", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                msg_buffer[((63-i)*8) +: 8] = i[7:0];
            end

            message = msg_buffer;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h1e90538f9b9643447c21085022067140f7f3292416801905329124a9a0166258);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
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
        input [255:0] expected_hash;
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
        $dumpvars(0,clk, message, rst, start, done, hash);
    end

endmodule
