`timescale 1ns/1ps

module pci_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg [31:0] data_in;
    reg request;
    reg reset;
    reg write;
    wire [31:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pci_endpoint_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .request(request),
        .reset(reset),
        .write(write),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request = 0;
            write = 0;
            address = 0;
            data_in = 0;
            #20;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            while (!ready) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Write and Read back", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h0000_0010;
            data_in = 32'hA5A5_B6B6;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            write = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'h0000_0010;
            write = 0;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);

            #1;


            check_outputs(32'hA5A5_B6B6, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Verify storage at different addresses", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h0000_0020;
            data_in = 32'h1111_2222;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'h0000_0030;
            data_in = 32'h3333_4444;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'h0000_0020;
            write = 0;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);

            #1;


            check_outputs(32'h1111_2222, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Overwrite data at the same address", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'h0000_0040;
            data_in = 32'hDEAD_BEEF;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'h0000_0040;
            data_in = 32'hCAFE_BABE;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'h0000_0040;
            write = 0;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);

            #1;


            check_outputs(32'hCAFE_BABE, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Read from uninitialized address", test_num);
            reset_dut();

            @(posedge clk);
            address = 32'h0000_00F0;
            write = 0;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            #1;



            check_outputs(32'h0000_0000, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary address check (0xFFFFFFFF)", test_num);
            reset_dut();


            @(posedge clk);
            address = 32'hFFFF_FFFF;
            data_in = 32'h8888_7777;
            write = 1;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);


            @(posedge clk);
            address = 32'hFFFF_FFFF;
            write = 0;
            request = 1;
            @(posedge clk);
            request = 0;
            while (!ready) @(posedge clk);

            #1;


            check_outputs(32'h8888_7777, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pci_endpoint_controller Testbench");
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
        input [31:0] expected_data_out;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,address, clk, data_in, request, reset, write, data_out, ready);
    end

endmodule
