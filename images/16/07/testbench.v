`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg [63:0] key;
    reg rst;
    wire [63:0] encrypted_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
        .clk(clk),
        .data(data),
        .key(key),
        .rst(rst),
        .encrypted_data(encrypted_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 64'b0;
            key = 64'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Input", test_num);
            reset_dut();

            data = 64'h0000000000000000;
            key  = 64'h0000000000000000;


            @(posedge clk);
            #1;



            #1;




            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Input", test_num);
            reset_dut();

            data = 64'hFFFFFFFFFFFFFFFF;
            key  = 64'hFFFFFFFFFFFFFFFF;

            @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            data = 64'hAAAAAAAAAAAAAAAA;
            key  = 64'h5555555555555555;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hex Sequence Data", test_num);
            reset_dut();

            data = 64'h0123456789ABCDEF;
            key  = 64'hFEDCBA9876543210;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Inputs", test_num);
            reset_dut();

            data = 64'hDEADBEEFCAFEBABE;
            key  = 64'h0102030405060708;

            @(posedge clk);
            #1;


            #1;



            check_outputs(64'hDEADBEEFCAFEBABE ^ 64'h0102030405060708);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Bit Key", test_num);
            reset_dut();

            data = 64'h0000000000000000;
            key  = 64'h8000000000000000;

            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h8000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, data, key, rst, encrypted_data);
    end

endmodule
