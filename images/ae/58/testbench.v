`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg [7:0] read_addr;
    reg we;
    reg [7:0] write_addr;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .clk(clk),
        .din(din),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            write_addr = 0;
            read_addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 8'h10;
            din = 8'hA5;

            @(negedge clk);
            we = 0;


            read_addr = 8'h10;


            @(posedge clk);
            #2;

            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 8'hFF;
            din = 8'hFF;

            @(negedge clk);
            we = 0;
            read_addr = 8'hFF;

            @(posedge clk);
            #2;

            $display("Testcase 002: Boundary Address 0xFF");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 8'h00;
            din = 8'h5A;

            @(negedge clk);
            we = 0;
            read_addr = 8'h00;

            @(posedge clk);
            #2;

            $display("Testcase 003: Boundary Address 0x00");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(negedge clk);
            we = 1; write_addr = 8'h20; din = 8'h11;
            @(negedge clk);


            we = 0; write_addr = 8'h20; din = 8'hEE;
            @(negedge clk);


            read_addr = 8'h20;
            @(posedge clk);
            #2;

            $display("Testcase 004: Write Enable Check (we=0)");
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(negedge clk);
            we = 1; write_addr = 8'h30; din = 8'hCC;
            @(negedge clk);
            we = 0;


            @(negedge clk);
            we = 1;
            write_addr = 8'h40;
            din = 8'hDD;
            read_addr = 8'h30;

            @(posedge clk);
            #2;

            $display("Testcase 005: Simultaneous Read/Write");
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram Testbench");
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, read_addr, we, write_addr, dout);
    end

endmodule
