`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] msg_in;
    reg msg_valid;
    reg rst;
    wire [127:0] hash_out;
    wire hash_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .msg_in(msg_in),
        .msg_valid(msg_valid),
        .rst(rst),
        .hash_out(hash_out),
        .hash_valid(hash_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            msg_in = 512'b0;
            msg_valid = 1'b0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros", test_num);
            reset_dut();

            msg_in = 512'h0;
            msg_valid = 1'b1;
            @(posedge clk);
            msg_valid = 1'b0;


            while (!hash_valid) @(posedge clk);


            #1;



            check_outputs(128'hf1aa098869c994f108c903a45c61304b, 1'b1);
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones", test_num);
            reset_dut();

            msg_in = {16{32'hFFFFFFFF}};
            msg_valid = 1'b1;
            @(posedge clk);
            msg_valid = 1'b0;

            while (!hash_valid) @(posedge clk);


            #1;



            check_outputs(128'h54668a67926715f333792015df37a94a, 1'b1);
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bits (0xAAAA...)", test_num);
            reset_dut();

            msg_in = {64{8'hAA}};
            msg_valid = 1'b1;
            @(posedge clk);
            msg_valid = 1'b0;

            while (!hash_valid) @(posedge clk);

            #1;


            check_outputs(128'h09230623315995537618991316518596, 1'b1);
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase004;

        integer i;
        reg [511:0] pattern;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Incremental Pattern", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end

            msg_in = pattern;
            msg_valid = 1'b1;
            @(posedge clk);
            msg_valid = 1'b0;

            while (!hash_valid) @(posedge clk);

            #1;


            check_outputs(128'h0c6396911f97486e9690196881919869, 1'b1);
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Repeated 32-bit Word (0x12345678)", test_num);
            reset_dut();

            msg_in = {16{32'h12345678}};
            msg_valid = 1'b1;
            @(posedge clk);
            msg_valid = 1'b0;

            while (!hash_valid) @(posedge clk);

            #1;


            check_outputs(128'h77914841961694939016186981881515, 1'b1);
            repeat(2) @(posedge clk);
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
        input [127:0] expected_hash_out;
        input expected_hash_valid;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out) &&
                expected_hash_valid === (expected_hash_valid ^ hash_valid ^ expected_hash_valid)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h, hash_valid=%b",
                         hash_out, hash_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h, hash_valid=%b",
                         expected_hash_out, expected_hash_valid);
                $display("  Got:      hash_out=%h, hash_valid=%b",
                         hash_out, hash_valid);
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
        $dumpvars(0,clk, msg_in, msg_valid, rst, hash_out, hash_valid);
    end

endmodule
