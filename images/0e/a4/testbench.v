`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg read;
    reg rst;
    reg write;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .rst(rst),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 0;
            data_in = 0;
            read = 0;
            write = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write and Read...");
            reset_dut();


            addr = 4'h4;
            data_in = 8'hA5;
            write = 1;
            read = 0;
            @(posedge clk);


            write = 0;
            read = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Sequential Writes...");
            reset_dut();


            addr = 4'h1; data_in = 8'h11; write = 1;
            @(posedge clk);

            addr = 4'h2; data_in = 8'h22; write = 1;
            @(posedge clk);

            addr = 4'h3; data_in = 8'h33; write = 1;
            @(posedge clk);


            write = 0;
            read = 1;
            addr = 4'h2;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Overwriting Data...");
            reset_dut();


            addr = 4'h7;
            data_in = 8'hCC;
            write = 1;
            @(posedge clk);


            data_in = 8'hDD;
            write = 1;
            @(posedge clk);


            write = 0;
            read = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(8'hDD);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Boundary Address (0xF)...");
            reset_dut();


            addr = 4'hF;
            data_in = 8'hFF;
            write = 1;
            @(posedge clk);


            write = 0;
            read = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Read after Reset (Expect 0)...");
            reset_dut();


            addr = 4'h0;
            read = 1;
            write = 0;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Alternating R/W...");
            reset_dut();


            addr = 4'hA; data_in = 8'hAA; write = 1; read = 0;
            @(posedge clk);


            addr = 4'hB; data_in = 8'hBB; write = 1; read = 0;
            @(posedge clk);


            addr = 4'hA; write = 0; read = 1;
            @(posedge clk);
            #1;

            if (data_out !== 8'hAA) begin
                $display("Mid-test failure at addr 0xA");
                fail_count = fail_count + 1;
            end else begin

                addr = 4'hB; write = 0; read = 1;
                @(posedge clk);
                #1 #1;
 check_outputs(8'hBB);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        $dumpvars(0,addr, clk, data_in, read, rst, write, data_out);
    end

endmodule
