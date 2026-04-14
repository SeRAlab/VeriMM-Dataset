`timescale 1ns/1ps

module reg_file_8x64_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr;
    reg [2:0] write_addr;
    reg [63:0] write_data;
    reg write_enable;
    wire [63:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_8x64 dut (
        .clk(clk),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            write_enable = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Basic Write and Read at Addr 0");
            reset_dut();
            test_num = 1;


            write_enable = 1;
            write_addr = 3'd0;
            write_data = 64'hFEEDFACECAFEBABE;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_addr = 3'd0;
            #2;

            #1;


            check_outputs(64'hFEEDFACECAFEBABE);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Write and Read at Addr 7");
            reset_dut();
            test_num = 2;

            write_enable = 1;
            write_addr = 3'd7;
            write_data = 64'h1234567890ABCDEF;
            @(posedge clk);
            #1;
            write_enable = 0;

            read_addr = 3'd7;
            #2;

            #1;


            check_outputs(64'h1234567890ABCDEF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Verify Write Enable logic (WE=0)");
            reset_dut();
            test_num = 3;


            write_enable = 1;
            write_addr = 3'd4;
            write_data = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #1;


            write_enable = 0;
            write_addr = 3'd4;
            write_data = 64'h5555555555555555;
            @(posedge clk);
            #1;

            read_addr = 3'd4;
            #2;


            #1;



            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Asynchronous Read Check");
            reset_dut();
            test_num = 4;


            write_enable = 1;
            write_addr = 3'd1;
            write_data = 64'h0000000000000001;
            @(posedge clk);
            #1;
            write_addr = 3'd2;
            write_data = 64'h0000000000000002;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_addr = 3'd1;
            #2;
            if (read_data !== 64'h1) begin
                $display("Sub-test failed: Read Addr 1 failed");
            end

            read_addr = 3'd2;
            #2;

            #1;


            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Multiple Register Writes");
            reset_dut();
            test_num = 5;

            write_enable = 1;

            write_addr = 3'd0; write_data = 64'hA; @(posedge clk); #1;
            write_addr = 3'd1; write_data = 64'hB; @(posedge clk); #1;
            write_addr = 3'd2; write_data = 64'hC; @(posedge clk); #1;
            write_enable = 0;

            read_addr = 3'd1;
            #2;

            #1;


            check_outputs(64'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_8x64 Testbench");
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
        input [63:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_addr, write_addr, write_data, write_enable, read_data);
    end

endmodule
