`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr;
    reg clk;
    reg [15:0] din;
    reg read_en;
    reg write_en;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .read_en(read_en),
        .write_en(write_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            read_en  <= 0;
            write_en <= 0;
            addr     <= 0;
            din      <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read at address 0", test_num);


            @(posedge clk);
            addr     <= 7'h00;
            din      <= 16'hABCD;
            write_en <= 1;
            read_en  <= 0;


            @(posedge clk);
            write_en <= 0;


            @(posedge clk);
            addr     <= 7'h00;
            read_en  <= 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Boundary Write and Read at address 127", test_num);


            @(posedge clk);
            addr     <= 7'h7F;
            din      <= 16'hFFFF;
            write_en <= 1;
            read_en  <= 0;

            @(posedge clk);
            write_en <= 0;


            @(posedge clk);
            addr     <= 7'h7F;
            read_en  <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Overwrite Data", test_num);


            @(posedge clk);
            addr <= 7'h25; din <= 16'h1111; write_en <= 1; read_en <= 0;
            @(posedge clk);

            addr <= 7'h25; din <= 16'h2222; write_en <= 1; read_en <= 0;
            @(posedge clk);
            write_en <= 0;


            @(posedge clk);
            addr <= 7'h25; read_en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Address Isolation Check", test_num);


            @(posedge clk);
            addr <= 7'h0A; din <= 16'hAAAA; write_en <= 1; read_en <= 0;
            @(posedge clk);

            addr <= 7'h0B; din <= 16'hBBBB; write_en <= 1; read_en <= 0;
            @(posedge clk);
            write_en <= 0;


            @(posedge clk);
            addr <= 7'h0A; read_en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Read Enable Low Check", test_num);


            @(posedge clk);
            addr <= 7'h50; din <= 16'h5555; write_en <= 1; read_en <= 0;
            @(posedge clk);
            write_en <= 0;


            @(posedge clk);
            addr <= 7'h50; read_en <= 0;
            @(posedge clk);
            #1;







            addr <= 7'h50; read_en <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, read_en, write_en, dout);
    end

endmodule
