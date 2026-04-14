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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %0d: All Zeros Block", test_num);
            reset_dut();


            message = 512'h0;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hda5698be17b9b46962335799779f11bb37d74a445c4501a2b0e7d3c0c058e374);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %0d: 'abc' String Padded", test_num);
            reset_dut();


            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %0d: 448-bit Test String Padded", test_num);
            reset_dut();



            message = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F707180000000000001C0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %0d: All 0x01 Block", test_num);
            reset_dut();


            message = {64{8'h01}};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h0443423758b958862f995f50f75726207f2df292061902096384260d2962123d);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %0d: Sequential Processing Test", test_num);
            reset_dut();


            message = 512'h0;
            start = 1; @(posedge clk); start = 0;
            wait(done);
            @(posedge clk);


            reset_dut();
            message = {64{8'hFF}};
            start = 1; @(posedge clk); start = 0;
            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'ha68305c754d92410714ed0362f6b8c8d8c28f14299b8b093129532889e90089e);
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
