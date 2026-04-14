`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    reg start;
    wire [255:0] hash;
    wire hash_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .start(start),
        .hash(hash),
        .hash_ready(hash_ready)
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
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 512-bit Zero Block", test_num);
            reset_dut();

            message = 512'h0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            while (!hash_ready) @(posedge clk);


            #1;



            check_outputs(256'hda94541544c4e0e5616f06a43926615b3e2777083a216503c80a8c279a7738ee, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 'abc' with standard padding", test_num);
            reset_dut();

            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!hash_ready) @(posedge clk);


            #1;



            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 64 bytes of 'a'", test_num);
            reset_dut();

            message = {64{8'h61}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!hash_ready) @(posedge clk);


            #1;



            check_outputs(256'hf7846f55cf23e14eebeab05140560211c21fa53d27402774a89c5132962571bc, 1'b1);
        end
        endtask

    task testcase004;

        reg [511:0] msg_buffer;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 512-bit Incrementing Block (0x00 to 0x3F)", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                msg_buffer[((63-i)*8) +: 8] = i[7:0];
            end

            message = msg_buffer;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            while (!hash_ready) @(posedge clk);


            #1;



            check_outputs(256'hcbc120531201588636b135c3c0b11e9a38549704259b9da4e13e64850785167e, 1'b1);
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
        input [255:0] expected_hash;
        input expected_hash_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_hash_ready === (expected_hash_ready ^ hash_ready ^ expected_hash_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, hash_ready=%b",
                         hash, hash_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, hash_ready=%b",
                         expected_hash, expected_hash_ready);
                $display("  Got:      hash=%h, hash_ready=%b",
                         hash, hash_ready);
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
        $dumpvars(0,clk, message, reset, start, hash, hash_ready);
    end

endmodule
