`timescale 1ns/1ps

module dual_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] r_addr;
    reg [7:0] w_addr;
    reg [15:0] w_data;
    reg we;
    wire [15:0] r_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram dut (
        .clk(clk),
        .r_addr(r_addr),
        .w_addr(w_addr),
        .w_data(w_data),
        .we(we),
        .r_data(r_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            w_addr = 0;
            w_data = 0;
            r_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            we = 1;
            w_addr = 8'h10;
            w_data = 16'hABCD;
            @(posedge clk);
            #1;


            we = 0;
            r_addr = 8'h10;
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
            $display("Testcase %0d: Boundary Address Testing", test_num);


            we = 1;
            w_addr = 8'h00;
            w_data = 16'h1111;
            @(posedge clk);
            #1;


            w_addr = 8'hFF;
            w_data = 16'hFFFF;
            @(posedge clk);
            #1;


            we = 0;
            r_addr = 8'hFF;
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
            $display("Testcase %0d: Write Enable Verification", test_num);


            we = 1;
            w_addr = 8'h20;
            w_data = 16'h55AA;
            @(posedge clk);
            #1;


            we = 0;
            w_addr = 8'h20;
            w_data = 16'hEEFF;
            @(posedge clk);
            #1;


            r_addr = 8'h20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h55AA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Simultaneous R/W Different Addresses", test_num);


            we = 1;
            w_addr = 8'h30;
            w_data = 16'h1234;
            @(posedge clk);
            #1;


            we = 1;
            w_addr = 8'h31;
            w_data = 16'h5678;
            r_addr = 8'h30;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Data Overwrite", test_num);


            we = 1;
            w_addr = 8'h40;
            w_data = 16'hAAAA;
            @(posedge clk);
            #1;


            w_addr = 8'h40;
            w_data = 16'hBBBB;
            @(posedge clk);
            #1;

            we = 0;
            r_addr = 8'h40;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hBBBB);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Consecutive Read After Write", test_num);


            we = 1;
            w_addr = 8'h50;
            w_data = 16'h7777;
            @(posedge clk);
            #1;


            we = 0;
            r_addr = 8'h50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h7777);
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
        input [15:0] expected_r_data;
        begin
            if (expected_r_data === (expected_r_data ^ r_data ^ expected_r_data)) begin
                $display("PASS");
                $display("  Outputs: r_data=%h",
                         r_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data=%h",
                         expected_r_data);
                $display("  Got:      r_data=%h",
                         r_data);
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
        $dumpvars(0,clk, r_addr, w_addr, w_data, we, r_data);
    end

endmodule
