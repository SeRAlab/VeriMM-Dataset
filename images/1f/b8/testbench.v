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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: 512 bits of 0x00", test_num);
            reset_dut();
            message = 512'h0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: 512 bits of 0x61 ('a')", test_num);
            reset_dut();
            message = {64{8'h61}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 256'hcf5b16a778afdec001802992456456f345c22530182419409ed517409249c122);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Sequential pattern 0x00 to 0x3F", test_num);
            reset_dut();
            message = 512'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 256'hc6488340d87a7164920409c1356e9c9103e5c94d0e90924619d084c8a299580b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: 512 bits of 0xFF", test_num);
            reset_dut();
            message = {64{8'hff}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(1'b1, 256'hef1a559286d0607996f014e19b5f3964971f11a4361e3895e6f6631b51821013);
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
