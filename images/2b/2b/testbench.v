`timescale 1ns/1ps

module sha256_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg [255:0] prev_hash;
    reg rst;
    wire [255:0] new_hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_compression dut (
        .clk(clk),
        .message(message),
        .prev_hash(prev_hash),
        .rst(rst),
        .new_hash(new_hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 0;
            prev_hash = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Message 'abc'", test_num);
            reset_dut();


            prev_hash = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;



            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;


            repeat (80) @(posedge clk);

            #1;


            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Empty Message", test_num);
            reset_dut();

            prev_hash = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;


            message = 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;

            repeat (80) @(posedge clk);

            #1;


            check_outputs(256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Message 'a'", test_num);
            reset_dut();

            prev_hash = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;



            message = 512'h61800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008;

            repeat (80) @(posedge clk);

            #1;


            check_outputs(256'hca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero block", test_num);
            reset_dut();

            prev_hash = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
            message = 512'h0;

            repeat (80) @(posedge clk);


            #1;



            check_outputs(256'hda5698be17b9b46962335799779fbeca8ce5d491c0d26243bafef94183c24468);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_compression Testbench");
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
        input [255:0] expected_new_hash;
        begin
            if (expected_new_hash === (expected_new_hash ^ new_hash ^ expected_new_hash)) begin
                $display("PASS");
                $display("  Outputs: new_hash=%h",
                         new_hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hash=%h",
                         expected_new_hash);
                $display("  Got:      new_hash=%h",
                         new_hash);
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
        $dumpvars(0,clk, message, prev_hash, rst, new_hash);
    end

endmodule
