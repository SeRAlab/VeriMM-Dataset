`timescale 1ns/1ps

module sha256_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] current_hash;
    reg [511:0] message_block;
    reg rst;
    wire [255:0] new_hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_compression dut (
        .clk(clk),
        .current_hash(current_hash),
        .message_block(message_block),
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
            current_hash = 0;
            message_block = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();
            current_hash = 256'h0;
            message_block = 512'h0;


            @(posedge clk);
            #1;


            #1;



            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Input", test_num);
            reset_dut();
            current_hash = {8{32'hFFFFFFFF}};
            message_block = {16{32'hFFFFFFFF}};

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();
            current_hash = {8{32'hAAAAAAAA}};
            message_block = {16{32'h55555555}};

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SHA-256 Initial Constants", test_num);
            reset_dut();
            current_hash[255:224] = 32'h6a09e667;
            current_hash[223:192] = 32'hbb67ae85;
            current_hash[191:160] = 32'h3c6ef372;
            current_hash[159:128] = 32'ha54ff53a;
            current_hash[127:96]  = 32'h510e527f;
            current_hash[95:64]   = 32'h9b05688c;
            current_hash[63:32]   = 32'h1f83d9ab;
            current_hash[31:0]    = 32'h5be0cd19;

            message_block = 512'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'hE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Walking Ones Message", test_num);
            reset_dut();
            current_hash = 256'h0;
            message_block = 512'h1;

            @(posedge clk);
            #1;


            #1;



            check_outputs(256'h1);
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
        $dumpvars(0,clk, current_hash, message_block, rst, new_hash);
    end

endmodule
