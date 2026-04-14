`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] msg;
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
        .msg(msg),
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
            msg = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Hashing padded 'abc'", test_num);

            msg = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);

            #1;


            check_outputs(1'b1, 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Hashing 512 bits of zeros", test_num);

            msg = 512'h0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 256'hda5698d85298f24b1303216c810d7a0491062a420b98a0006764d85836c17e65);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Hashing 512 bits of ones", test_num);

            msg = {16{32'hFFFFFFFF}};
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 256'hc6ba907f303290678d91c7a52e18507856c9a3da2b8003f6f966113b2c15337b);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Hashing 64 'A' characters", test_num);

            msg = {64{8'h41}};
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(1'b1, 256'h5152069279744c847d06637e6f8510a911a37c4d5d4d38865660233045618588);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Reset sequence test", test_num);


            msg = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);


            reset_dut();
            msg = 512'h0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);

            #1;


            check_outputs(1'b1, 256'hda5698d85298f24b1303216c810d7a0491062a420b98a0006764d85836c17e65);
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
        $dumpvars(0,clk, msg, rst, start, done, hash);
    end

endmodule
