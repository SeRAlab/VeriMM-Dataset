`timescale 1ns/1ps

module dual_port_ram_16x16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr;
    reg [3:0] write_addr;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram_16x16 dut (
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
            @(posedge clk);
            read_addr = 0;
            write_addr = 0;
            write_data = 0;
            write_enable = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            write_addr = 4'h5;
            write_data = 16'hAAAA;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_enable = 0;
            read_addr = 4'h5;


            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Write and Read (Different Addr)", test_num);
            reset_dut();


            @(negedge clk);
            write_addr = 4'h2;
            write_data = 16'h1234;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_addr = 4'h8;
            write_data = 16'h5678;
            write_enable = 1;
            read_addr = 4'h2;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwriting a memory location", test_num);
            reset_dut();


            @(negedge clk);
            write_addr = 4'hA;
            write_data = 16'h1111;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_data = 16'h2222;
            @(posedge clk);


            @(negedge clk);
            write_enable = 0;
            read_addr = 4'hA;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable validation", test_num);
            reset_dut();


            @(negedge clk);
            write_addr = 4'h7;
            write_data = 16'hFFFF;
            write_enable = 0;
            @(posedge clk);


            @(negedge clk);
            read_addr = 4'h7;
            @(posedge clk);

            #1;


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary address check (Addr 15)", test_num);
            reset_dut();


            @(negedge clk);
            write_addr = 4'hF;
            write_data = 16'hDEAD;
            write_enable = 1;
            @(posedge clk);


            @(negedge clk);
            write_enable = 0;
            read_addr = 4'hF;
            @(posedge clk);

            #1;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram_16x16 Testbench");
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
        input [15:0] expected_read_data;
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
