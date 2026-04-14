`timescale 1ns/1ps

module simple_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg rst;
    reg start;
    wire done;
    wire [255:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_sha256 dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .done(done),
        .hash_out(hash_out)
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
        data_in = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: All Zeros", test_num);
        reset_dut();

        data_in = 256'h0;
        start = 1;
        @(posedge clk);
        start = 0;


        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'hE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: All Ones", test_num);
        reset_dut();

        data_in = {256{1'b1}};
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'hDA39A3EE5E6B4B0D3255BFEF95601890AFD80709);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: Alternating Bits (0xA5A5...)", test_num);
        reset_dut();

        data_in = {32{8'hA5}};
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'h7F1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: Sequential Bytes", test_num);
        reset_dut();


        data_in = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'hFCDEAB8967452301FCDEAB8967452301FCDEAB8967452301FCDEAB8967452301);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nRunning Test Case %0d: Re-run same data", test_num);
        reset_dut();

        data_in = 256'hDEADBEEFCAFEBABE123456788765432100001111222233334444555566667777;
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done);
        @(posedge clk);


        #1;



        check_outputs(1'b1, 256'h55555555AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_sha256 Testbench");
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
        input [255:0] expected_hash_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash_out=%h",
                         done, hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash_out=%h",
                         expected_done, expected_hash_out);
                $display("  Got:      done=%b, hash_out=%h",
                         done, hash_out);
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
        $dumpvars(0,clk, data_in, rst, start, done, hash_out);
    end

endmodule
