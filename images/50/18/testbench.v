`timescale 1ns/1ps

module dual_port_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_addr1;
    reg [4:0] read_addr2;
    reg [4:0] write_addr1;
    reg [4:0] write_addr2;
    reg [31:0] write_data1;
    reg [31:0] write_data2;
    reg write_enable1;
    reg write_enable2;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_memory dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr1(write_addr1),
        .write_addr2(write_addr2),
        .write_data1(write_data1),
        .write_data2(write_data2),
        .write_enable1(write_enable1),
        .write_enable2(write_enable2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            read_addr1 <= 0;
            read_addr2 <= 0;
            write_addr1 <= 0;
            write_addr2 <= 0;
            write_data1 <= 0;
            write_data2 <= 0;
            write_enable1 <= 0;
            write_enable2 <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Port 1 Write and Read...");
            reset_dut();


            write_addr1 <= 5'h05;
            write_data1 <= 32'hA1A1A1A1;
            write_enable1 <= 1'b1;
            @(posedge clk);
            #1;
            write_enable1 <= 1'b0;



            read_addr1 <= 5'h05;
            read_addr2 <= 5'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hA1A1A1A1, read_data2);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Port 2 Write and Read...");
            reset_dut();


            write_addr2 <= 5'h0A;
            write_data2 <= 32'hB2B2B2B2;
            write_enable2 <= 1'b1;
            @(posedge clk);
            #1;
            write_enable2 <= 1'b0;


            read_addr1 <= 5'h00;
            read_addr2 <= 5'h0A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(read_data1, 32'hB2B2B2B2);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Simultaneous Dual Port Access...");
            reset_dut();


            write_addr1 <= 5'h0F;
            write_data1 <= 32'hC3C3C3C3;
            write_enable1 <= 1'b1;
            write_addr2 <= 5'h14;
            write_data2 <= 32'hD4D4D4D4;
            write_enable2 <= 1'b1;
            @(posedge clk);
            #1;
            write_enable1 <= 1'b0;
            write_enable2 <= 1'b0;


            read_addr1 <= 5'h0F;
            read_addr2 <= 5'h14;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hC3C3C3C3, 32'hD4D4D4D4);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Dual Port Read from Same Address...");
            reset_dut();


            write_addr1 <= 5'h19;
            write_data1 <= 32'hE5E5E5E5;
            write_enable1 <= 1'b1;
            @(posedge clk);
            #1;
            write_enable1 <= 1'b0;


            read_addr1 <= 5'h19;
            read_addr2 <= 5'h19;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hE5E5E5E5, 32'hE5E5E5E5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write Enable Check...");
            reset_dut();


            write_addr1 <= 5'h1E;
            write_data1 <= 32'hF6F6F6F6;
            write_enable1 <= 1'b1;
            @(posedge clk);
            #1;


            write_data1 <= 32'h00000000;
            write_enable1 <= 1'b0;
            @(posedge clk);
            #1;


            read_addr1 <= 5'h1E;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hF6F6F6F6, read_data2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_memory Testbench");
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
        input [31:0] expected_read_data1;
        input [31:0] expected_read_data2;
        begin
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
        $dumpvars(0,clk, read_addr1, read_addr2, write_addr1, write_addr2, write_data1, write_data2, write_enable1, write_enable2, read_data1, read_data2);
    end

endmodule
