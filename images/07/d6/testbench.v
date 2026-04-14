`timescale 1ns/1ps

module simple_DES_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg [55:0] key;
    reg start;
    wire [63:0] encrypted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_DES dut (
        .clk(clk),
        .data(data),
        .key(key),
        .start(start),
        .encrypted_data(encrypted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            data = 64'h0;
            key = 56'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            reset_dut();
            data = 64'h0000000000000000;
            key  = 56'h00000000000000;
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h8CA64DE9C1B123A7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones", test_num);
            reset_dut();
            data = 64'hFFFFFFFFFFFFFFFF;
            key  = 56'hFFFFFFFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Bits (A/5)", test_num);
            reset_dut();
            data = 64'hAAAAAAAAAAAAAAAA;
            key  = 56'h55555555555555;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'hB5841495E95201C3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Hex Sequence", test_num);
            reset_dut();
            data = 64'h0123456789ABCDEF;
            key  = 56'h133457799BBCDF;
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h3FA40E8A984D4815);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_DES Testbench");
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
        input [63:0] expected_encrypted_data;
        begin
            if (expected_encrypted_data === (expected_encrypted_data ^ encrypted_data ^ expected_encrypted_data)) begin
                $display("PASS");
                $display("  Outputs: encrypted_data=%h",
                         encrypted_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_data=%h",
                         expected_encrypted_data);
                $display("  Got:      encrypted_data=%h",
                         encrypted_data);
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
        $dumpvars(0,clk, data, key, start, encrypted_data);
    end

endmodule
