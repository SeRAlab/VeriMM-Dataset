`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] read_address;
    reg we;
    reg [7:0] write_address;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .clk(clk),
        .data_in(data_in),
        .read_address(read_address),
        .we(we),
        .write_address(write_address),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        write_address = 0;
        read_address = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read", test_num);
        reset_dut();


        we = 1;
        write_address = 8'h10;
        data_in = 8'h55;
        @(posedge clk);
        #1;
        we = 0;


        read_address = 8'h10;
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sequential Writes and Reads", test_num);
        reset_dut();


        we = 1;
        write_address = 8'h20;
        data_in = 8'hAA;
        @(posedge clk);
        #1;


        write_address = 8'h21;
        data_in = 8'hBB;
        @(posedge clk);
        #1;
        we = 0;


        read_address = 8'h21;
        #1;
        if (data_out !== 8'hBB) begin
            #1;

            check_outputs(8'hBB);
        end else begin

            read_address = 8'h20;
            #1;
            #1;

            check_outputs(8'hAA);
        end
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify Write Enable logic", test_num);
        reset_dut();


        we = 1;
        write_address = 8'h40;
        data_in = 8'h11;
        @(posedge clk);
        #1;


        we = 0;
        write_address = 8'h40;
        data_in = 8'hEE;
        @(posedge clk);
        #1;


        read_address = 8'h40;
        #1;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simultaneous Port Operation (Write A, Read B)", test_num);
        reset_dut();


        we = 1;
        write_address = 8'h50;
        data_in = 8'hCC;
        @(posedge clk);
        #1;


        we = 1;
        write_address = 8'h60;
        data_in = 8'hDD;
        read_address = 8'h50;


        #1;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwriting data at same address", test_num);
        reset_dut();


        we = 1;
        write_address = 8'hFF;
        data_in = 8'h01;
        @(posedge clk);
        #1;


        data_in = 8'h02;
        @(posedge clk);
        #1;
        we = 0;


        read_address = 8'hFF;
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary address 0x00", test_num);
        reset_dut();

        we = 1;
        write_address = 8'h00;
        data_in = 8'h7F;
        @(posedge clk);
        #1;
        we = 0;

        read_address = 8'h00;
        #1;
        #1;

        check_outputs(8'h7F);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_address, we, write_address, data_out);
    end

endmodule
