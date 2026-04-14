`timescale 1ns/1ps

module sha256_tb;

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
    sha256 dut (
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
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Zeros", test_num);

            data_in = 256'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Ones", test_num);

            data_in = {256{1'b1}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Alternating Bits 0x55", test_num);

            data_in = {64{4'h5}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h5555555555555555555555555555555555555555555555555555555555555555);
        end
        endtask

    task testcase004;

        reg [255:0] pattern;
        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Incremental Byte Pattern", test_num);

            for (i = 0; i < 32; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end

            data_in = pattern;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F);
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
