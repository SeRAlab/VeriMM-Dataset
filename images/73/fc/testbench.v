`timescale 1ns/1ps

module dual_port_mem_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr;
    reg we;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_mem dut (
        .clk(clk),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data(read_data)
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
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Basic Write and Read", test_num);

            @(negedge clk);
            we = 1;
            write_addr = 4'h0;
            write_data = 8'hA5;
            read_addr = 4'h0;

            @(negedge clk);
            we = 0;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Boundary Address Write/Read", test_num);

            @(negedge clk);
            we = 1;
            write_addr = 4'hF;
            write_data = 8'h5A;
            read_addr = 4'hF;

            @(negedge clk);
            we = 0;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Write Enable Test (we=0)", test_num);


            @(negedge clk);
            we = 1;
            write_addr = 4'h5;
            write_data = 8'h11;
            @(negedge clk);


            we = 0;
            write_addr = 4'h5;
            write_data = 8'h22;
            read_addr = 4'h5;
            @(negedge clk);

            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Overwrite Test", test_num);


            @(negedge clk);
            we = 1;
            write_addr = 4'h7;
            write_data = 8'hAA;
            @(negedge clk);


            write_data = 8'hBB;
            read_addr = 4'h7;
            @(negedge clk);

            we = 0;
            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Independent Port Access", test_num);


            @(negedge clk);
            we = 1;
            write_addr = 4'h2;
            write_data = 8'hCC;
            @(negedge clk);


            we = 1;
            write_addr = 4'h3;
            write_data = 8'hDD;
            read_addr = 4'h2;
            @(negedge clk);

            we = 0;
            #2;
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
        $display("dual_port_mem Testbench");
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
        input [7:0] expected_read_data;
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
        $dumpvars(0,clk, read_addr, we, write_addr, write_data, read_data);
    end

endmodule
