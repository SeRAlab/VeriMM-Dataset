`timescale 1ns/1ps

module md5_simplified_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data;
    reg start;
    wire done;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_simplified dut (
        .clk(clk),
        .data(data),
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
            start = 0;
            data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (512-bit 0x00...0)", test_num);
            reset_dut();

            data = 512'h0;
            start = 1;
            @(posedge clk);
            #1 start = 0;


            wait(done == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 128'h3b061d4b6840742588102a78f24458f3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (512-bit 0xFF...F)", test_num);
            reset_dut();

            data = {16{32'hFFFFFFFF}};
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 128'h23c103133649982f643e2a22533ed03f);
        end
        endtask

    task testcase003;

        integer i;
        reg [511:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Pattern (0x000102...)", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[(i*8) +: 8] = i[7:0];
            end

            data = pattern;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 128'h68069324093952f10c26884ac66795f0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern (0xAAAA...)", test_num);
            reset_dut();

            data = {16{32'hAAAAAAAA}};
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done == 1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 128'h51630138d306443cd08c1055df4b01e9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_simplified Testbench");
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
        $dumpvars(0,clk, data, start, done, hash);
    end

endmodule
