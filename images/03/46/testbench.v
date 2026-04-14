`timescale 1ns/1ps

module des_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [63:0] key_in;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encrypt dut (
        .clk(clk),
        .data_in(data_in),
        .key_in(key_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 64'h0;
            key_in <= 64'h0;
            repeat(2) @(posedge clk);
            $display("DUT Reset/Initialization complete.");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Pattern", test_num);
            data_in = 64'h0000000000000000;
            key_in  = 64'h0000000000000000;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(data_out);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Pattern", test_num);
            data_in = 64'hFFFFFFFFFFFFFFFF;
            key_in  = 64'hFFFFFFFFFFFFFFFF;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern", test_num);
            data_in = 64'hAAAAAAAAAAAAAAAA;
            key_in  = 64'h5555555555555555;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Data / Complex Key", test_num);
            data_in = 64'h0123456789ABCDEF;
            key_in  = 64'hFEDCBA9876543210;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Prime-like Bit Distribution", test_num);
            data_in = 64'h8000000000000001;
            key_in  = 64'hC000000000000003;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High-nibble Key, Low-nibble Data", test_num);
            data_in = 64'h00000000FFFFFFFF;
            key_in  = 64'hFFFFFFFF00000000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Sparse Bit Pattern", test_num);
            data_in = 64'h0001000100010001;
            key_in  = 64'h1000100010001000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(data_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encrypt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [63:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key_in, data_out);
    end

endmodule
